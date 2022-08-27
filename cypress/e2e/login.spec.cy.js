describe("Login Spec", () => {
  it("allows login with email", () => {
    cy.visit("/login")
    cy.get("#main-navbar").contains("Log in").click()

    cy.url().should("include", "/login")
    cy.get('input[name="user[login]"]').type("admin@example.com")
    cy.get('input[name="user[password]"]').type("Password1!")
    cy.get('.form-actions input[type="submit"]').click()

    cy.contains("Signed in successfully.")
    cy.url().should("eq", Cypress.config().baseUrl)

    cy.getCookie("_final_furlong_session").should("exist")
  })

  it("allows login with username", () => {
    cy.visit("/login")
    cy.get("#main-navbar").contains("Log in").click()

    cy.url().should("include", "/login")
    cy.get('input[name="user[login]"]').type("admin123")
    cy.get('input[name="user[password]"]').type("Password1!")
    cy.get('.form-actions input[type="submit"]').click()

    cy.contains("Signed in successfully.")
    cy.url().should("eq", Cypress.config().baseUrl)

    cy.getCookie("_final_furlong_session").should("exist")
  })

  it("supports remember me", () => {
    cy.visit("/login")
    cy.get("#main-navbar").contains("Log in").click()

    cy.url().should("include", "/login")
    cy.get('input[name="user[login]"]').type("admin@example.com")
    cy.get('input[name="user[password]"]').type("Password1!")
    cy.get('input[id="user_remember_me"]').check()
    cy.get('.form-actions input[type="submit"]').click()

    cy.contains("Signed in successfully.")
    cy.url().should("eq", Cypress.config().baseUrl)

    cy.getCookie("remember_user_token").should("exist")
  })

  it("does not log in with empty values", () => {
    cy.visit("/login")
    cy.get("#main-navbar").contains("Log in").click()

    cy.url().should("include", "/login")
    cy.get('.form-actions input[type="submit"]').click()

    cy.contains("Invalid Login or password")
    cy.url().should("include", "/login")

    cy.getCookie("_final_furlong_session").should("not.exist")
  })
})

// expect(page).to have_text t("devise.sessions.signed_in")
// end
//
// it "can login with email" do
//   visit root_path
// within ".navbar" do
//   expect(page).to have_link t("layouts.nav.login"), href: new_user_session_path
//
// click_on t("layouts.nav.login")
// end
//
// expect(page).to have_field "user[login]"
//
// within ".simple_form" do
//   fill_in "user[login]", with: user[:email]
// fill_in "user[password]", with: password
// click_on t("devise.sessions.new.sign_in")
// end
//
// expect(page).to have_text t("devise.sessions.signed_in")
// end
// end
//
// context "when invalid" do
//   it "shows errors" do
//   visit new_user_session_path
// within ".simple_form" do
//   expect(page).to have_field "user[login]"
//
// fill_in "user[login]", with: user[:username]
// fill_in "user[password]", with: "super-seekrit"
// click_on t("devise.sessions.new.sign_in")
// end
//
// expect(page).to have_text t("devise.failure.invalid", authentication_keys: "Login")
// end
// end
// end
