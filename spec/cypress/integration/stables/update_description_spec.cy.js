describe("Update Stable Description", () => {
  it("does not allow updating as anonymous user", () => {
    cy.visit("/stable/edit")

    cy.url().should("eq", Cypress.config().baseUrl + "login")
  })

  it("does allow updating as matching user", () => {
    cy.factoryBotCreate({ factory: "stable" })
      .its("body")
      .then(stable => {
        cy.login({ id: stable.user_id }).then(() => {
          cy.visit("/stable/edit")

          cy.get('textarea[name="stable[description]"]').should("exist")
        })
      })
  })
})
