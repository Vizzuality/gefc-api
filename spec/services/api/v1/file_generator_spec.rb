require "rails_helper"

RSpec.describe API::V1::FileGenerator do
  let(:indicator) { create(:indicator) }
  let!(:record1) { create(:record, indicator: indicator, category_1_en: "xxx", year: 2020) }
  let!(:record2) { create(:record, indicator: indicator, category_1_en: "yyy", year: 2021) }

  context "when records and locale are provided" do
    before do
      ENV["DOWNLOADS_PATH"] = "/spec/files/downloads/"
    end
    after do
      dir_path = "#{Rails.root}#{ENV["DOWNLOADS_PATH"]}"
      Dir.foreach(dir_path) do |f|
        fn = File.join(dir_path, f)
        File.delete(fn) if f != "." && f != ".." && f != ".keep"
      end
      ENV["DOWNLOADS_PATH"] = nil
    end

    it "returns a file name" do
      file_format = "csv"
      file_generator = API::V1::FileGenerator.new(indicator.records, file_format, :en)

      expect(file_generator.call.class).to eq(String)
    end
    it "returns a file name composed by the indicator name, date and proper extension" do
      file_format = "csv"
      file_generator = API::V1::FileGenerator.new(indicator.records, file_format, :en)

      file_name, extension_in_file_name = file_generator.call.split(".")
      puts file_name
      elements_of_the_file_name = file_name.split("_")
      indicator_in_file_name = elements_of_the_file_name.first
      date_time_in_file_name = elements_of_the_file_name.last

      expect(elements_of_the_file_name.count).to eq(2)
      expect(indicator_in_file_name.include?(Slugable.sanitize_name(indicator.name_en))).to eq(true)
      expect(DateTime.strptime(date_time_in_file_name).class).to eq(DateTime)
      expect(extension_in_file_name).to eq(file_format)
    end
    it "generates a csv file with the proper extension" do
      file_format = "csv"
      file_path = API::V1::FileGenerator.new(indicator.records, file_format, :en).call
      expect(File.exist?(file_path)).to eq(true)
      expect(File.extname(file_path)).to eq(".#{file_format}")
    end
    it "generates a csv file with number of rows = number of records" do
      file_format = "csv"
      file_path = API::V1::FileGenerator.new(indicator.records, file_format, :en).call
      csv_data = []
      CSV.foreach(file_path, headers: true, converters: :numeric).with_index do |row, index|
        row_data = row.to_hash.transform_keys! { |key| key.to_s.downcase }
        csv_data << row_data
      end
      expect(csv_data.count).to eq(indicator.records.count)
    end
    it "generates a json file with the proper extension" do
      file_format = "json"
      file_path = API::V1::FileGenerator.new(indicator.records, file_format, :en).call
      expect(File.exist?(file_path)).to eq(true)
      expect(File.extname(file_path)).to eq(".#{file_format}")
    end
    it "generates an xml file with the proper extension" do
      file_format = "xml"
      file_path = API::V1::FileGenerator.new(indicator.records, file_format, :en).call
      expect(File.exist?(file_path)).to eq(true)
      expect(File.extname(file_path)).to eq(".#{file_format}")
    end

    xit "generates a file with the proper language" do
    end
  end
  context "when no locale is provided" do
    xit "uses default locale" do
    end
  end
  context "when records is empty" do
    xit "returns an error message" do
    end
  end
end
