require 'guard/compat/plugin'
require 'guard/pytest/version'

require 'shellwords'

module Guard
  class Pytest < Plugin
    def initialize(options = {})
      super
    end

    def start
    end

    def stop
    end

    def reload
    end

    def run_all
      remove_pyc if options[:remove_pyc]

      if options[:run_all_option]
        opts = options[:run_all_option]
      else
        opts = options[:pytest_option]
      end

      dir = options[:pytest_dir]

      run_tests(opts, dir)
      true
    end

    def run_on_modifications(paths)
      remove_pyc if options[:remove_pyc]

      dir = options[:pytest_dir]

      run_tests(options[:pytest_option], dir, paths.uniq)

      run_all if options[:all_after_pass]

      true
    end

    private

    def run_tests(opts, dir=nil, files=nil)
      opts = Shellwords.shellsplit(opts)

      if dir
        result = Dir.chdir(dir) { system('py.test', *opts, *files) }
      else
        result = system('py.test', *opts, *files)
      end

      throw(:task_has_failed) unless result
    end

    def remove_pyc
      if options[:pyc_dirs]
        options[:pyc_dirs].each do |dir|
          system("find #{dir} -name '*.pyc' | xargs rm")
        end
      else
        system("find . -name '*.pyc' | xargs rm")
      end
    end

  end
end
