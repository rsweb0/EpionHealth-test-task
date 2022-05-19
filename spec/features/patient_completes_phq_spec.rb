require "rails_helper"

RSpec.feature "A patient checks into the app", js: true do
  let(:check_in) { create(:check_in) }

  scenario "for a scheduled appointment" do
    visit root_path

    click_on "Start check in"

    expect(page).to have_content "Please complete all of the steps on this page"

    click_on "Start PHQ screener"

    expect(page).to have_content("Over the past 2 weeks, how often have you been bothered by any of the following problems?")

    Screener::QUESTIONS[1].each do |question|
      expect(page).to have_content(question)
    end
  end

  scenario "with answers choosen" do
    visit check_in_path(check_in)

    click_on "Start PHQ screener"

    click_on("Complete check in")

    expect(page).to have_content("You need to answer each question.")
  end

  scenario "with some answers choosen" do
    visit check_in_path(check_in)

    click_on "Start PHQ screener"

    within "#screenerQuestion1" do
      choose("Not at all")
    end

    click_on("Complete check in")

    expect(page).to have_content("You need to answer each question.")
  end

  scenario "with all answers choosen and high scored" do
    visit check_in_path(check_in)

    click_on "Start PHQ screener"

    within "#screenerQuestion1" do
      choose("Nearly every day")
    end
    within "#screenerQuestion2" do
      choose("Not at all")
    end

    click_on("Complete check in")

    expect(page).to have_content("Your response has been recorded successfully.")
    expect(page).to have_content("Additional screening should be completed.")

    Screener::QUESTIONS[2].each do |question|
      expect(page).to have_content(question)
    end
  end

  scenario "with all answers choosen and not high scored" do
    visit check_in_path(check_in)

    click_on "Start PHQ screener"

    within "#screenerQuestion1" do
      choose("Not at all")
    end
    within "#screenerQuestion2" do
      choose("Not at all")
    end

    click_on("Complete check in")

    expect(page).to have_content("Your response has been recorded successfully.")
    expect(page).to have_content("Additional screening is not needed.")
  end
end
