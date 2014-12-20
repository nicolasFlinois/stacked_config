module StackedConfig
  module SourceHelper

    OS_FLAVOURS = {
        mingw32: :windows,
        linux: :unix
    }
    DEFAULT_OS_FLAVOUR = :unix

    SYSTEM_CONFIG_ROOT = {
        windows: [File.join(ENV['systemRoot'] || '', 'Config')],
        unix: '/etc'
    }

    EXTENSIONS = %w(conf CONF cfg CFG yml YML yaml YAML)

    def self.os_flavour
      OS_FLAVOURS[RbConfig::CONFIG['target_os'].to_sym] || DEFAULT_OS_FLAVOUR
    end

    def self.supported_oses
      OS_FLAVOURS.values.sort.uniq
    end

    def self.system_config_root
      SYSTEM_CONFIG_ROOT[os_flavour]
    end


    def supported_oses
      StackedConfig::SourceHelper.supported_oses
    end

    def os_flavour
      @os_flavour ||= StackedConfig::SourceHelper.os_flavour
    end

    def system_config_root
      StackedConfig::SourceHelper.system_config_root
    end

    def set_config_file(places)
      @file_name = nil
      places.each do |path_array|
        # Perform path substitutions
        potential_config_file = File.join(path_array.map do |path_part|
          perform_substitutions path_part
        end)
        # Try to find config file with extension
        EXTENSIONS.each do |extension|
          file  = potential_config_file.gsub '##EXTENSION##', extension
          if File.readable? file
            @file_name = file
            return @file_name
          end
        end
      end
    end



    def perform_substitutions path_part
      res = path_part.dup
      res.gsub! '##SYSTEM_CONFIG_ROOT##', system_config_root
      res.gsub! '##PROGRAM_NAME##', File.basename($PROGRAM_NAME)
      res
    end


  end
end
