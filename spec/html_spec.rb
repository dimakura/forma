# -*- encoding : utf-8 -*-
require 'spec_helper'

RSpec.describe Forma::Html do
  specify{ expect(Forma::Html.el).to eq('<div/>') }
  specify{ expect(Forma::Html.el('button', {disabled: true})).to eq('<button disabled/>') }
  specify{ expect(Forma::Html.el('button', {disabled: false})).to eq('<button/>') }
  specify{ expect(Forma::Html.el(['content'])).to eq('<div>content</div>') }
  specify{ expect(Forma::Html.el(['content'], {id: 'main'})).to eq('<div id="main">content</div>') }
  specify{ expect(Forma::Html.el(['content'], {id: 'main', class: 'large-text'})).to eq('<div id="main" class="large-text">content</div>') }
end
