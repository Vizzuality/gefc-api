require 'rails_helper'
require 'csv'

RSpec.describe GroupsImporter, type: :model do
  let(:file_path) { "spec/files/local_csv/groups_import_test.csv" }
  # Happy path with a valid CSV.
  #
  it "creates exact number of records for a valid csv" do
    arr_of_rows = CSV.read(file_path, headers: true)

    expect{ GroupsImporter.new.import_from_csv(file_path) }.to change{ Record.all.count }.by(arr_of_rows.count)
  end

  it "creates exact number of groups for a valid csv" do
    expect{ GroupsImporter.new.import_from_csv(file_path) }.to change{ Group.all.count }.by(1)
  end

  # Atention! we are using a csv with 9 rows with line set to true
  #
  it "establish a relationship between record and the assigned widgets" do
    arr_of_rows = CSV.read(file_path, headers: true)

    expect { GroupsImporter.new.import_from_csv(file_path) }.to change {
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

    expect { GroupsImporter.new.import_from_csv(file_path) }.to_not change{ RecordWidget.where(widget: non_assigned_widgets).count }
  end
end
