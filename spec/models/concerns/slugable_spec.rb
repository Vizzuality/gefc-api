require "rails_helper"

RSpec.describe Slugable do
  it "provides a slug for any of the classes" do
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

  it "removes non standar characters" do
    group = build(:group, name_en: "noodless & fun")
    group.set_slug

    sanitized_slug = group.name_en.downcase.strip.gsub(/[[:space:]]/, "-").gsub(/[^\w-]/, "")

    expect(group.slug).to eq(sanitized_slug)
  end

  it "adds subgroup as a prefix if the object is an indicator" do
    indicator = build(:indicator)
    indicator.set_slug

    indicator_sanitized_slug = indicator.name_en.downcase.strip.gsub(/[[:space:]]/, "-").gsub(/[^\w-]/, "")
    subgroup_sanitized_slug = indicator.subgroup.name_en.downcase.strip.gsub(/[[:space:]]/, "-").gsub(/[^\w-]/, "")
    sanitized_slug = subgroup_sanitized_slug + "-" + indicator_sanitized_slug

    expect(indicator.slug).to eq(sanitized_slug)
  end
end
