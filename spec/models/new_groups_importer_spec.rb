require 'rails_helper'
require 'integration_helper'
require 'csv'

RSpec.describe NewGroupsImporter, type: :model do
  #let(:file_path) { "public/to_upload/gedp_dat_01122021.csv" }
  # let(:file_path) { "spec/files/local_csv/new_groups_import_test copy.csv" }
  let(:file_path) { "spec/files/local_csv/140000.csv" }
  # Happy path with a valid CSV.
  #
  it "creates exact number of records for a valid csv" do
    arr_of_rows = CSV.read(file_path, headers: true)

    expect{ NewGroupsImporter.new.import_from_csv(file_path) }.to change{ Record.all.count }.by(arr_of_rows.count)
  end

  it "creates 1 region" do
    expect { NewGroupsImporter.new.import_from_csv(file_path) }.to change{ Region.count }.by(1)
  end
  it "creates 2 units" do
    expect { NewGroupsImporter.new.import_from_csv(file_path) }.to change{ Unit.count }.by(2)
  end
  
  it "creates exact number of groups for a valid csv" do
    expect{ NewGroupsImporter.new.import_from_csv(file_path) }.to change{ Group.all.count }.by(2)
  end

  it "creates two subgroups" do
    expect { NewGroupsImporter.new.import_from_csv(file_path) }.to change{ Subgroup.count }.by(2)
  end

  it "establish a relationship between group and subgroup" do
    NewGroupsImporter.new.import_from_csv(file_path)
    Subgroup.all.each do |subgroup|
      expect(subgroup.group.present?).to eq(true)
      expect(subgroup.by_default).to eq(false)
    end
  end

  it "creates 2 indicators" do
    expect { NewGroupsImporter.new.import_from_csv(file_path) }.to change{ Indicator.count }.by(2)
  end

  it "establish a relationship between subgroup and indicator" do
    NewGroupsImporter.new.import_from_csv(file_path)
    Indicator.all.each do |indicator|
      expect(indicator.subgroup.present?).to eq(true)
      expect(indicator.by_default).to eq(false)
    end
  end

  # # Atention! we are using a csv with 9 rows with line set to true.
  # # TODO generate csv with some widget set to true.
  # #
  it "establish a relationship between record and the assigned widgets" do
    arr_of_rows = CSV.read(file_path, headers: true)

    expect { NewGroupsImporter.new.import_from_csv(file_path) }.to change {
      line = Widget.find_by_name('line')
      RecordWidget.where(widget: line).count
    }.by(arr_of_rows.count)
  end

  it "does not stablish a relationship between record and non assigned widgets" do
    arr_of_rows = CSV.read(file_path, headers: true)
    chart = create(:widget, name: 'chart')
    pie = create(:widget, name: 'pie')
    choropleth = create(:widget, name: 'choropleth')
    non_assigned_widgets = [pie, chart, choropleth]

    expect { NewGroupsImporter.new.import_from_csv(file_path) }.to_not change{ RecordWidget.where(widget: non_assigned_widgets).count }
  end
end
