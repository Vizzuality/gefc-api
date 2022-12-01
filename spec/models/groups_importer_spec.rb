require "rails_helper"
require "integration_helper"
require "csv"

RSpec.describe GroupsImporter, type: :model do
  let(:file_path) { "spec/files/local_csv/groups_import_test.csv" }
  let(:folder_path) { "spec/files/local_csv/" }
  # Happy path with a valid CSV.

  after(:each) do
    RecordWidget.delete_all
    Record.delete_all
    Widget.delete_all
    Indicator.delete_all
    Subgroup.delete_all
    Group.delete_all
  end

  it "creates exact number of records for a valid csv" do
    arr_of_rows = CSV.read(file_path, headers: true)

    expect { GroupsImporter.new.import_from_folder(folder_path) }.to change { Record.all.count }.by(arr_of_rows.count)
  end

  it "creates exact number of groups for a valid csv" do
    expect { GroupsImporter.new.import_from_folder(folder_path) }.to change { Group.all.count }.by(1)
  end

  # Attention! we are using a csv with 9 rows with line set to true.
  # TODO generate csv with some widget set to true.
  #
  it "establish a relationship between record and the assigned widgets" do
    arr_of_rows = CSV.read(file_path, headers: true)

    expect { GroupsImporter.new.import_from_folder(folder_path) }.to change {
      line = Widget.find_by_name("line")
      RecordWidget.where(widget: line).count
    }.by(arr_of_rows.count)
  end

  it "does not establish a relationship between record and non assigned widgets" do
    CSV.read(file_path, headers: true)
    line = create(:widget, name: "line")
    chart = create(:widget, name: "chart")
    pie = create(:widget, name: "pie")
    choropleth = create(:widget, name: "choropleth")
    non_assigned_widgets = [pie, chart, choropleth, line]

    expect { GroupsImporter.new.import_from_folder(folder_path) }.to change { RecordWidget.where(widget: non_assigned_widgets).count }.by(10)
  end

  it "creates two subgroups" do
    expect { GroupsImporter.new.import_from_folder(folder_path) }.to change { Subgroup.count }.by(2)
  end

  it "establish a relationship between group and subgroup" do
    GroupsImporter.new.import_from_folder(folder_path)
    Subgroup.all.each do |subgroup|
      expect(subgroup.group.present?).to eq(true)
      expect(subgroup.by_default).to eq(false)
    end
  end

  it "creates 3 indicators" do
    expect { GroupsImporter.new.import_from_folder(folder_path) }.to change { Indicator.count }.by(3)
  end

  it "establish a relationship between subgroup and indicator" do
    GroupsImporter.new.import_from_folder(folder_path)
    Indicator.all.each do |indicator|
      expect(indicator.subgroup.present?).to eq(true)
      expect(indicator.by_default).to eq(false)
    end
  end
end
