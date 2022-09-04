describe("Update Stable Description", () => {
  it("does not allow updating as anonymous user", () => {
    cy.visit("/stable/edit")

    cy.url().should("eq", Cypress.config().baseUrl + "login")
  })

  context("when user is logged in", () => {
    it("allows updating as matching user", () => {
      cy.factoryBotCreate({ factory: "stable" })
        .its("body")
        .then(stable => {
          cy.login({ id: stable.user_id }).then(() => {
            cy.visit("/stable/edit")

            cy.get('textarea[name="stable[description]"]').should("exist")
          })
        })
    })

    it("follows accessibility rules", () => {
      cy.factoryBotCreate({ factory: "stable" })
        .its("body")
        .then(stable => {
          cy.login({ id: stable.user_id }).then(() => {
            cy.testA11y("/stable/edit")
          })
        })
    })
  })
})
