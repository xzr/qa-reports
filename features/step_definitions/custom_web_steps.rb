Then /^show me the response$/ do
  puts page.body.inspect
end

When /submit the form(?: at "([^"]*)")?$/ do |form_id|
  target = form_id ? "#"+form_id : "input[@type='submit']"
  find(target).click
end


Then /^the link "([^"]*)" within "([^"]*)" should point to the report "([^"]*)"/ do |link, selector, expected_report|
  with_scope(selector) do
    field = find_link(link)

    version, target, test_type, hardware = expected_report.downcase.split('/')
    report = MeegoTestSession.first(:conditions =>
     {:release_version => version, :target => target, :hwproduct => hardware, :testtype => test_type}
    )
    raise "report not found with parameters #{version}/#{target}/#{hardware}/#{test_type}!" unless report

    field[:href].should == "/#{version.capitalize}/#{target.capitalize}/#{test_type.capitalize}/#{hardware.capitalize}/#{report.id}"
  end
end

When /^I click the element "([^"]*)"$/ do |selector|
  find(selector).click
end

When /^fill in "([^"]*)" within "([^"]*)" with:$/ do |field, selector, data|
  with_scope(selector) do
    fill_in(field, :with => data)
  end
end


Then /^(?:|I )should find element "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_selector(text)
    else
      assert page.has_selector?(text)
    end
  end
end

Then /^(?:|I )should not find element "([^"]*)"(?: within "([^"]*)")?$/ do |text, selector|
  with_scope(selector) do
    if page.respond_to? :should
      page.should have_no_selector(text)
    else
      assert page.has_no_selector?(text)
    end
  end
end