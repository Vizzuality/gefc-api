require "rails_helper"
require "csv"

RSpec.describe WidgetsImporter, type: :model do
  let(:file_path) { "spec/files/local_json/widgets_import_test.json" }

  before(:all) do
    group = Group.create({name_en: "Socioeconomic"})
    subgroup = Subgroup.create({name_en: "Agriculture", group: group})
    Indicator.create({name_en: "Total Power of Agricultural Machinery", subgroup: subgroup}).save!
    Indicator.create({name_en: "Farm Machinery", subgroup: subgroup}).save!
    Indicator.create({name_en: "Irrigated Area of Cultivated Land", subgroup: subgroup}).save!
    Indicator.create({name_en: "Consumption of Chemical Fertilizers", subgroup: subgroup}).save!
    Indicator.create({name_en: "Irrigated Areas", subgroup: subgroup}).save!
  end

  after(:all) do
    Indicator.delete_all
    Subgroup.delete_all
    Group.delete_all
  end

  # Happy path with a valid JSON.
  #
  # Attention! we are using a json with 5 elements
  #
  it "creates exact number of indicators for a valid json" do
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    expect { WidgetsImporter.new.import_from_file(file_path) }.to change { IndicatorWidget.all.count }.by((data_hash.map { |e| e["widget"].count }).sum)
  end
  it "sets Indicator.by_default for each indicator" do
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    WidgetsImporter.new.import_from_file(file_path)
    data_hash.each do |indicator_data|
      expect(Indicator.find_by(name_en: indicator_data["indicator_en"]).by_default).to eq(indicator_data["default"])
    end
  end
  it "sets a relationship between Indicator and Widgets" do
    file = File.read(file_path)
    data_hash = JSON.parse(file)
    WidgetsImporter.new.import_from_file(file_path)
    data_hash.each do |indicator_data|
      expect(Indicator.find_by(name_en: indicator_data["indicator_en"]).widgets.pluck(:name).sort).to eq(indicator_data["widget"].sort)
    end
  end
  it "sets subgroup_default for each Group" do
    file = File.read("spec/files/local_json/default_group_import_test.json")
    data_hash = JSON.parse(file)
    WidgetsImporter.new.import_from_file("spec/files/local_json/default_group_import_test.json")
    data_hash.each do |indicator_data|
      if indicator_data["classification"]["subgroup_default"] == true
        expect(Group.find_by(name_en: indicator_data["classification"]["group_en"]).default_subgroup).to eq(Subgroup.find_by(name_en: indicator_data["classification"]["subgroup_en"]))
      else

        expect(Group.find_by(name_en: indicator_data["classification"]["group_en"]).default_subgroup).to_not eq(Subgroup.find_by(name_en: indicator_data["classification"]["subgroup_en"]))
      end
    end
  end
end
