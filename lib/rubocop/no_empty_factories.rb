# frozen_string_literal: true

module RuboCop
  module Cop
    module Custom
      class NoEmptyFactories < Cop
        include RangeHelp

        def_node_matcher :empty_factory_definition?, <<~PATTERN
          (block
            (send nil? :factory ...)
            args
            nil?)
        PATTERN

        def_node_matcher :empty_factory_bot_define?, <<~PATTERN
          (block
            (send
              (const nil? :FactoryBot)
              :define)
            args
            nil?)
        PATTERN

        MSG = 'Empty factory definition detected'

        def investigate(processed_source)
          puts "processed_source.file_path #{processed_source.file_path}"
          # For whatever reason this cop keeps inspecting our bin/ files and
          # I couldn't stop it with the exclude config in rubocop
          return unless processed_source.file_path.include?('spec/factories')

          range = source_range(processed_source.buffer, 1, 0)
          add_offense(nil, location: range, message: MSG) if processed_source.ast.nil?
        end

        def on_block(node)
          empty_factory_bot_define?(node) do
            add_offense(node)
          end

          empty_factory_definition?(node) do
            add_offense(node)
          end
        end
      end
    end
  end
end
