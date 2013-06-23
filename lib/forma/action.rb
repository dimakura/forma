# -*- encoding : utf-8 -*-
module Forma
  class Action
    include Forma::Html
    # attr_reader :label, :icon, :method, :confirm, :as
    attr_reader :url 

    def initialize(h={})
      h = h.symbolize_keys
      @id = h[:id]
      @label = h[:label]
      @icon = h[:icon]
      @url = h[:url]
      @method = h[:method]
      @confirm = h[:confirm]
      @as = h[:as]
      @tooltip = h[:tooltip]
      @select = h[:select]
      @condition = h[:condition]
    end

    def to_html(model)
      if eval_condition(model)
        if @select
          el(
            'a',
            attrs: {
              id: @id, class: ['ff-action', 'btn', 'btn-mini', 'ff-select-action'],
              href: '#', 'data-original-title' => @tooltip,
              'data-value-id' => model.id, 'data-value-text' => model.to_s
            },
            children: [ el('i', attrs: { class: 'icon icon-download' }) ]
          )
        else
          children = [ (el('img', attrs: { src: @icon }) if @icon.present?), el('span', text: eval_label(model)) ]
          button = (@as.to_s == 'button')
          el(
            'a',
            attrs: {
              id: @id,
              class: ['ff-action', ('btn btn' if button)],
              href: eval_url(model), 'data-method' => @method, 'data-confirm' => @confirm,
              'data-original-title' => @tooltip
            },
            children: children
          )
        end
      end
    end

    private

    def eval_url(model)
      @url.is_a?(Proc) ? @url.call(model) : @url.to_s
    end

    def eval_label(model)
      @label.is_a?(Proc) ? @label.call(model) : @label.to_s
    end

    def eval_condition(model)
      if @condition then @condition.is_a?(Proc) ? @condition.call(model) : @condition
      else true end
    end
  end
end
