feature 'Cooking cookies' do
  scenario 'Cooking a single cookie' do
    user = create_and_signin
    oven = user.ovens.first

    visit oven_path(oven)

    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    click_link_or_button 'Prepare Cookies'
    fill_in 'Fillings', with: 'Chocolate Chip'
    fill_in 'cookie_quantity', with: 2
    click_button 'Mix and bake'

    expect(current_path).to eq(oven_path(oven))
    expect(page).to have_content 'Chocolate Chip'
    expect(page).to have_content 'Your Cookie is Ready'

    click_button 'Retrieve Cookies'
    expect(page).to_not have_content 'Chocolate Chip'
    expect(page).to_not have_content 'Your Cookie is Ready'

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '2 Cookies'
    end
  end

  scenario 'Trying to bake a cookie while oven is full' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    click_link_or_button 'Prepare Cookies'
    fill_in 'fillings', with: 'Chocolate Chip'
    fill_in 'cookie_quantity', with: 2
    # fill_in 'Fillings', with: 'Chocolate Chip'
    click_button 'Mix and bake'

    click_link_or_button  'Prepare Cookies'
    expect(page).to have_content 'Some cookies are already in the oven!'
    expect(current_path).to eq(oven_path(oven))
    expect(page).to_not have_button 'Mix and bake'
  end

  scenario 'Baking multiple cookies' do
    user = create_and_signin
    oven = user.ovens.first

    oven = FactoryGirl.create(:oven, user: user)
    visit oven_path(oven)

    3.times do
      click_link_or_button 'Prepare Cookies'
      fill_in 'fillings', with: 'Chocolate Chip'
      fill_in 'cookie_quantity', with: 1
      # fill_in 'Fillings', with: 'Chocolate Chip'
      click_button 'Mix and bake'

      click_button 'Retrieve Cookies'
    end

    visit root_path
    within '.store-inventory' do
      expect(page).to have_content '3 Cookies'
    end
  end
end
