# -*- encoding : utf-8 -*-
module Forma
  class Action
    include Forma::Html
    # attr_reader :label, :icon, :method, :confirm, :as
    attr_reader :url 

    def initialize(h={})
      h = h.symbolize_keys
      @label = h[:label]
      @icon = h[:icon]
      @url = h[:url]
      @method = h[:method]
      @confirm = h[:confirm]
      @as = h[:as]
      @tooltip = h[:tooltip]
    end

    def to_html(model)
      children = [ (el('img', attrs: { src: @icon }) if @icon.present?), el('span', text: eval_label(model)) ]
      button = (@as.to_s == 'button')
      el(
        'a',
        attrs: {
          class: ['ff-action', ('btn' if button)],
          href: eval_url(model), 'data-method' => @method, 'data-confirm' => @confirm,
          'data-original-title' => @tooltip
        },
        children: children
      )
    end

    private

    def eval_url(model)
      @url.is_a?(Proc) ? @url.call(model) : @url.to_s
    end

    def eval_label(model)
      @label.is_a?(Proc) ? @label.call(model) : @label.to_s
    end
  end
end
