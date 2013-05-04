# -*- encoding : utf-8 -*-
require 'spec_helper'

include Forma::Html

describe "attribute" do
  before(:all) do
    include Forma::Html
    @attr = attr("id", "forma4")
  end
  specify { @attr.to_s.should == %Q{id="forma4"} }
end

describe "class attribute" do
  before(:all) do
    @attr1 = attr("btn")
    @attr2 = attr(["btn", "btn-primary"])
  end
  specify { @attr1.to_s.should == %Q{class="btn"} }
  specify { @attr2.to_s.should == %Q{class="btn btn-primary"} }
end

describe "style attribute" do
  before(:all) do
    @attr = attr({"font-size" => "10px", "font-weight" => "bold"})
  end
  specify { @attr.to_s.should == %Q{style="font-size:10px;font-weight:bold"} }
end
