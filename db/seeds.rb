# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Widget.create([{ name: 'chart'}, { name: 'pie' }])
Group.create([{ name: 'group one'}, { name: 'group two' }])
Subgroup.create(name: 'subgroup one', group: Group.first)
first_indicator = Indicator.create(name: 'indicator one', subgroups: Subgroup.first)
first_indicator.widgets << Widget.first

Region.create(name: 'China', region_type:1)
Unit.create(name: 'km')
first_record = Record.create(value: 123.23, year:'1999', category_1:'cat one', category_2:'cat 2', indicator: Indicator.first, region: Region.first, unit: Unit.first)

first_record.widgets << Widget.first
