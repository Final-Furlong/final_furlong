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

  it("does not log in with invalid values", () => {
    cy.visit("/login")
    cy.get("#main-navbar").contains("Log in").click()

    cy.url().should("include", "/login")
    cy.get('input[name="user[login]"]').type("admin@example.com")
    cy.get('input[name="user[password]"]').type("secret")
    cy.get('.form-actions input[type="submit"]').click()

    cy.contains("Invalid Login or password")
    cy.url().should("include", "/login")

    cy.getCookie("_final_furlong_session").should("not.exist")
  })
})
