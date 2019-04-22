require File.dirname(__FILE__) + '/../spec_helper'
require "state_machine_checker"
require "state_machine_checker/rspec_matchers"

describe "Process state machine" do
  include StateMachineChecker::CTL::API
  include StateMachineChecker::RspecMatchers

  it "has no deadlock states" do
    f = neg EF(neg(EX(->(_) { true })))
    expect { new_process }.to satisfy(f)
  end

  it "can go down from any state" do
    f = AG(EX(:down?).or(:down?))
    expect { new_process }.to satisfy(f)
  end

  it "up is always reachable" do
    f = AG(EF(:up?))
    expect { new_process }.to satisfy(f)
  end

  it "can remain up indefinitely" do
    expect { new_process }.to satisfy(AG(atom(:up?).implies(EG(:up?))))
  end

  def new_process
    Eye::Process.new({:pid_file => '1.pid', :start_command => "a", :working_dir => "/tmp"})
  end
end
