require 'rspec/expectations'

RSpec::Matchers.define :match_jsonapi do |attributes|
  match do |records|
    attributes ||= []
    attributes = [attributes] unless attributes.respond_to?(:to_a)

    records ||= []
    records = [records] unless records.respond_to?(:to_a)

    data = response.parsed_body["data"]

    expect(data).to be_an(Array)
    expect(data.size).to eq(records.size)

    records.each_with_index do |record, i|
      resource = data[i]

      expect(resource).to be_a(Hash)
      expect(resource["attributes"]).to be_a(Hash)
      expect(resource["id"]).to eq(record.id.to_s)
      expect(resource["type"]).to eq(record.class.name.tableize)

      attributes.each do |attribute|
        expect(resource["attributes"][attribute.to_s]).to eq(record[attribute])
      end
    end
  end
end
