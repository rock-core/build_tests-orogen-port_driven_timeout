# frozen_string_literal: true

using_task_library "port_driven_timeout"

describe OroGen.port_driven_timeout.Task do
    run_live

    it "is port driven" do
        task = syskit_deploy_configure_and_start(OroGen.port_driven_timeout.Task)
        in_writer = syskit_create_writer(task.in_port)
        out_reader = syskit_create_reader(task.out_port)
        10.times do
            t = Time.now.floor(6)
            out_sample =
                expect_execution { syskit_write in_writer, { time: t } }
                .to { have_one_new_sample out_reader }

            assert_equal t, out_sample.last_received
            assert_in_delta t, out_sample.time, 0.25
        end
    end

    it "is triggered after the specified timeout" do
        task = syskit_deploy_configure_and_start(OroGen.port_driven_timeout.Task)
        in_writer = syskit_create_writer(task.in_port)
        out_reader = syskit_create_reader(task.out_port)

        t = Time.now.floor(6)
        out_sample =
            expect_execution { syskit_write in_writer, { time: t } }
            .to { have_one_new_sample out_reader }

        assert_equal t, out_sample.last_received
        assert_in_delta t, out_sample.time, 0.25

        out_sample =
            expect_execution
            .to { have_one_new_sample out_reader }
        assert_equal t, out_sample.last_received
        assert_operator(out_sample.time - t, :>, 0.48)
    end
end

