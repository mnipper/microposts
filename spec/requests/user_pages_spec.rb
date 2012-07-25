require 'spec_helper'

describe "UserPages" do
  describe "signup page" do
    subject { page }

    before { visit signup_path }

    it { should have_selector('h1', :text => 'Sign up') }
    it { should have_selector('title', :text => 'Sign up') }
  end
end
