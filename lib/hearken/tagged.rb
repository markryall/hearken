# frozen_string_literal: true

module Hearken
  module Tagged
    FILE_FIELDS = %w[path timestamp].freeze
    TAG_FIELDS = %w[album track title artist time date albumartist puid mbartistid mbalbumid mbalbumartistid asin].freeze
    FIELDS = FILE_FIELDS + TAG_FIELDS

    attr_accessor(*FIELDS.map(&:to_sym))

    def no_tag_fields?
      TAG_FIELDS.select { |field| send field }.empty?
    end

    def to_a
      FIELDS.map { |field| send field }
    end
  end
end
