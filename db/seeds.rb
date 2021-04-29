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
