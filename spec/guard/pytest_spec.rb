require 'spec_helper'
require 'shellwords'

RSpec.describe Guard::Pytest do
  let(:success_test) { 'spec/python/success.py' }
  let(:failure_test) { 'spec/python/failure.py' }
  let(:options) { {pytest_option: '--doctest-modules' } }
  subject { Guard::Pytest.new(options) }

  before(:each) do
    # catch all
    allow(subject).to receive(:system).and_return(true)
  end

  describe '#start' do
    it 'works' do
      subject.start
    end
  end

  describe '#stop' do
    it 'works' do
      subject.stop
    end
  end

  describe '#run_all' do
    it 'runs all tests with the given options' do
      expect(subject).to receive(:run_tests).with(options[:pytest_option])
      subject.run_all
    end

    context 'when :remove_pyc is set' do
      let(:options) { {pytest_option: '--doctest-modules', remove_pyc: true} }

      it 'calls #remove_pyc' do
        expect(subject).to receive(:remove_pyc)
        subject.run_all
      end
    end

    context 'when :remove_pyc is not set or false' do
      it 'does not call #remove_pyc' do
        expect(subject).to_not receive(:remove_pyc)
        subject.run_all
      end
    end

    context 'when :run_all_option is set' do
      let(:options) {
        {
          pytest_option: '--doctest-modules',
          run_all_option: '--foo --bar'
        }
      }

      it 'runs all tests with the run_all_option' do
        expect(subject).to receive(:run_tests).with(options[:run_all_option])
        subject.run_all
      end
    end

    it { expect(subject.run_all).to be_truthy }
  end

  describe '#run_on_modifications' do
    let(:paths) { ['foo', 'foo', 'bar'] }

    it 'runs tests with the given unique paths and options' do
      expect(subject).to receive(:run_tests)
        .with(options[:pytest_option], paths.uniq)

      subject.run_on_modifications(paths)
    end

    context 'when :all_after_pass is set' do
      let(:options) {
        {
          pytest_option: '--doctest-modules',
          all_after_pass: true
        }
      }
      it 'calls #run_all' do
        expect(subject).to receive(:run_all)
        subject.run_on_modifications(paths)
      end
    end

    it { expect(subject.run_on_modifications(paths)).to be_truthy }
  end

  context 'private methods' do
    describe '#run_tests' do
      let(:files) { ['foo', 'bar'] }

      it 'runs a py.test command with the given options and files' do
        expected = Shellwords.shellsplit(options[:pytest_option])
        expect(subject).to receive(:system)
          .with('py.test', *expected, *files)

        subject.send(:run_tests, options[:pytest_option], files)
      end

      context 'when the command fails' do
        before(:each) do
          allow(subject).to receive(:system).and_return(nil)
        end

        it {
          expect {
            subject.send(:run_tests, options[:pytest_option])
          }.to throw_symbol(:task_has_failed)
        }
      end
    end

    describe '#remove_pyc' do
      context 'when :pyc_dirs is set' do
        let(:options) {
          {pyc_dirs: ['tests', 'foo']}
        }

        it 'executes a command to remove the files in each specified directory' do
          options[:pyc_dirs].each do |dir|
            expect(subject).to receive(:system)
              .with("find #{dir} -name '*.pyc' | xargs rm")
          end

          subject.send(:remove_pyc)
        end
      end

      context 'when :pyc_dirs is not set' do
        it 'executes a command to remove all .pyc files' do
          expect(subject).to receive(:system)
            .with("find . -name '*.pyc' | xargs rm")

          subject.send(:remove_pyc)
        end
      end
    end
  end
end
