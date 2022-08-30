require "rails_helper"
require "csv"

RSpec.describe WidgetsImporter, type: :model do
  let(:file_path) { "spec/files/local_json/widgets_import_test.json" }

  # Happy path with a valid JSON.
  #
  # Atention! we are using a json with 5 elements
  #
  it "creates exact number of indicators for a valid json" do
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    expect { WidgetsImporter.new.import_from_json(file_path) }.to change { Indicator.all.count }.by(data_hash.count)
  end
  it "sets Indicator.by_default for each indicator" do
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    WidgetsImporter.new.import_from_json(file_path)
    data_hash.each do |indicator_data|
      expect(Indicator.find_by(name_en: indicator_data["indicator_en"]).by_default).to eq(indicator_data["default"])
    end
  end
  it "sets a relationship between Indicator and Widgets" do
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    WidgetsImporter.new.import_from_json(file_path)
    data_hash.each do |indicator_data|
      expect(Indicator.find_by(name_en: indicator_data["indicator_en"]).widgets.pluck(:name)).to eq(indicator_data["widget"])
    end
  end
  it "sets subgroup_default for each Group" do
    file = File.read("spec/files/local_json/default_group_import_test.json")
    data_hash = JSON.parse(file)
    WidgetsImporter.new.import_from_json("spec/files/local_json/default_group_import_test.json")
    data_hash.each do |indicator_data|
      if indicator_data["classification"]["subgroup_default"] == true
        expect(Group.find_by(name_en: indicator_data["classification"]["group_en"]).default_subgroup).to eq(Subgroup.find_by(name_en: indicator_data["classification"]["subgroup_en"]))
      else

        expect(Group.find_by(name_en: indicator_data["classification"]["group_en"]).default_subgroup).to_not eq(Subgroup.find_by(name_en: indicator_data["classification"]["subgroup_en"]))
      end
    end
  end
end
