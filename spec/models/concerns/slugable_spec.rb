require 'rails_helper'

RSpec.describe Slugable do
  it 'provides a slug for any of the classes' do
    group = build(:group)
    subgroup = build(:subgroup, group: group)
    indicator = build(:indicator)
    group.set_slug
    subgroup.set_slug
    indicator.set_slug

    expect(group.slug.blank?).to be(false)
    expect(subgroup.slug.blank?).to be(false)
    expect(indicator.slug.blank?).to be(false)
  end

  it 'removes non standar characters' do
    group = build(:group, name_en: 'noodless & fun')
    group.set_slug

    sanitaized_slug = group.name_en.downcase.strip.gsub(/[[:space:]]/, '-').gsub(/[^\w-]/,'')

    expect(group.slug).to eq(sanitaized_slug)
  end

  it 'adds subgroup as a prefix if the object is an indicator' do
    indicator = build(:indicator)
    indicator.set_slug

    indicator_sanitaized_slug = indicator.name_en.downcase.strip.gsub(/[[:space:]]/, '-').gsub(/[^\w-]/,'')
    subgroup_sanitaized_slug = indicator.subgroup.name_en.downcase.strip.gsub(/[[:space:]]/, '-').gsub(/[^\w-]/,'')
    sanitaized_slug = subgroup_sanitaized_slug + "-" + indicator_sanitaized_slug

    expect(indicator.slug).to eq(sanitaized_slug)
  end
end
