require 'aws_ssh_key'

module RakeCloudspin
  module Tasks
    class SshKeyTask < BaseTask

      def define
          desc "Ensure ssh keys for #{stack_name}"
          task :ssh_keys do
            ssh_keys_config = stack_config.ssh_keys
            ssh_keys_config.each { |ssh_key_name|
              key = AwsSshKey::Key.new(
                key_path: "/#{stack_config.estate}/#{stack_config.component}/#{stack_name}/#{stack_config.deployment_identifier}/ssh_key",
                key_name: ssh_key_name,
                aws_region: stack_config.region,
                tags: {
                  :Estate => stack_config.estate,
                  :Component => stack_config.component,
                  :Service => stack_name,
                  :DeploymentIdentifier => stack_config.deployment_identifier
                }
              )
              key.load
              key.write("work/#{stack_type}/#{stack_name}/ssh_keys/")
            }
          end

          task :plan => [ :ssh_keys ]
          task :provision => [ :ssh_keys ]
      end
    end
  end
end
