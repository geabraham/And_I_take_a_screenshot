
require 'euresource'
require 'eureka_tools'


Given(/^I am an authorized user of the Web App$/) do
  visit $BASE_URL
end

Given(/^the following Medidations exist$/) do |table|
    [
        {oid: "PRESIDENT", uuid: "8e19b514-5fa6-11e2-bcfd-0800200c9a66"},
        {oid: "SOFTWARE_ENGINEER", uuid: "8e19b515-5fa6-11e2-bcfd-0800200c9a66"},
        {oid: "VICE_PRESIDENT", uuid: "8e19b516-5fa6-11e2-bcfd-0800200c9a66"}
    ].each do |job_title_attrs|
      begin
        Euresource::JobTitle.get(job_title_attrs[:uuid])
      rescue
        Euresource::JobTitle.post(job_title_attrs)
      end

    end
    [
        {first_name: "John", last_name: "Smith", uuid: "1e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b514-5fa6-11e2-bcfd-0800200c9a66"},
        {first_name: "James", last_name: "Jones", uuid: "2e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b515-5fa6-11e2-bcfd-0800200c9a66"},
        {first_name: "John", last_name: "Chaplin", uuid: "3e19b515-5fa6-11e2-bcfd-0800200c9a69"},
        {first_name: "John", last_name: "Doe", uuid: "4e19b515-5fa6-11e2-bcfd-0800200c9a69", job_title_uuid: "8e19b516-5fa6-11e2-bcfd-0800200c9a66"},
        {first_name: "Tony", last_name: "Smith", uuid: "5e19b515-5fa6-11e2-bcfd-0800200c9a69"}
    ].each do |medidation_attrs|
      begin
        Euresource::Medidation.get(medidation_attrs[:uuid])
      rescue
        Euresource::Medidation.post(medidation_attrs)
      end
    end
end

Given(/^I navigate to Medidations tab$/) do
  visit $BASE_URL
end

Then(/^I see following Medidations$/) do |table|
  find("#medidations").all("tbody > tr").each_with_index do |row, i|
    fields = row.all "td"
    full_name =  fields[get_table_column_index("#medidations","First Name")].text + " " + fields[get_table_column_index("#medidations","Last Name")].text
    assert full_name == table.hashes[i][:Medidation], "Medidation full_name should be #{table.hashes[i][:Medidation]}"
    assert fields[get_table_column_index("#medidations","Job Title")].text == table.hashes[i]["Job Title"]
  end
end

Then(/^I should see "(.*?)" and "(.*?)" link besides each Medidation$/) do |arg1, arg2|
  first_link_counter = 0
  second_link_counter = 0
  find("#medidations").all("tbody > tr").each_with_index do |row, i|
    first_link_counter += 1 if row.find_link(arg1)
    second_link_counter += 1 if row.find_link(arg2)
  end
  assert first_link_counter == 5 , "should be 5 #{arg1} links,  counted #{first_link_counter}"
  assert second_link_counter == 5 , "should be 5 #{arg2} links,  counted #{second_link_counter}"
end

Then(/^I should see "(.*?)" link on the page$/) do |arg1|
  assert find_link(arg1)
end

When(/^I click on "(.*?)"$/) do |arg1|
  find("#medidations").all("tbody > tr").each_with_index do |row, i|
    fields = row.all "td"
    full_name =  fields[get_table_column_index("#medidations","First Name")].text + " " + fields[get_table_column_index("#medidations","Last Name")].text
    if full_name == arg1
      row.find_link("Edit").click
      break
    end
  end
end

Then(/^I should see the following details$/) do |table|
  table.hashes.each do |row|
    assert find_field(table.instance_variable_get("@col_names")[0]).value == row[table.instance_variable_get("@col_names")[0]]
  end
  #table.instance_variable_get("@columns").count
end

Given(/^I click on "(.*?)" link$/) do |arg1|
  find_link(arg1).click
end

Given(/^I fill in fields with following values:$/) do |table|

end

When(/^I click on "(.*?)" link \# this would be a link of button \?$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see success message "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)" in the list of records$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given(/^I click on "(.*?)" for "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

Given(/^I enter "(.*?)" in "(.*?)"$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end

When(/^I click on "(.*?)" button$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see a success message "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)"in the list of records$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Given(/^I see a pop up "(.*?)"$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

When(/^I answer "(.*?)" to the pop up window question$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should not see "(.*?)" in the list of records$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end
