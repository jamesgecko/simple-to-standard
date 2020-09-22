require 'securerandom'
require 'json'
require 'date'

class Note
  attr_reader :uuid, :tags

  def initialize(note_json)
    # puts note_json["id"] # Uncomment to see what note we fail on.
    @uuid = SecureRandom.uuid
    @title, @body = split_title(note_json['content'])
    @tags = note_json["tags"] || []
    @created_at = note_json["creationDate"]
    @updated_at = note_json["lastModified"]
  end

  def as_json
    {
      created_at: @created_at,
      updated_at: @updated_at,
      uuid: @uuid,
      content_type: "Note",
      content: {
        title: @title,
        text: @body,
        references: [],
        appData: {
          'org.standardnotes.sn' => {
            client_updated_at: @updated_at
          }
        }
      }
    }
  end

  private

  def split_title(content)
    split = content.index("\r\n")
    if split
      title = content[0...split]
      body_split = if content[split...split + 4] == "\r\n\r\n"
                    split + 4
                  else
                    split + 2
                  end
      body = content[body_split..-1]
      return [title, body]
    else
      [content, '']
    end
  end
end

class Tag
  attr_reader :uuid

  def initialize(name)
    @uuid = SecureRandom.uuid
    @name = name
    @references = []
  end

  def add_reference(note_uuid)
    @references << note_uuid
  end

  def as_json
    {
      uuid: @uuid,
      content_type: 'Tag',
      content: {
        title: @name,
        references: @references.map do |ref|
          {
            content_type: 'Note',
            uuid: ref
          }
        end
      }
    }
  end
end

class Tags
  def initialize
    @tags = {}
    import_tag_name = "#{Date.today.to_s}-import"
    @import_tag = Tag.new(import_tag_name)
    @tags[import_tag_name] = @import_tag
  end

  def from_note(note)
    @import_tag.add_reference(note.uuid)
    note.tags.each do |tag_name|
      @tags[tag_name] = Tag.new(tag_name) unless @tags[tag_name]
      @tags[tag_name].add_reference(note.uuid)
    end
  end

  def as_json
    @tags.values.map(&:as_json)
  end
end

def main
  tags = Tags.new
  notes = []
  trashed_notes = []

  import_json = JSON.parse(File.read('notes.json', encoding: 'UTF-8'))
  import_json["activeNotes"].each do |note_json|
    note = Note.new(note_json)
    tags.from_note(note)
    notes << note.as_json
  end
  # If you'd like to import deleted notes, take a look at export_json["trashedNotes"]

  output_json = JSON.pretty_generate({
    items: tags.as_json + notes + trashed_notes
  })
  File.write('standardified-notes.json', output_json, encoding: 'UTF-8')
  puts
  puts "standardified-notes.json generated with #{notes.count} notes."
end

main() if __FILE__ == $0
