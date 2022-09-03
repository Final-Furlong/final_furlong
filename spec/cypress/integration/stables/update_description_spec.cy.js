describe("Update Stable Description", () => {
  it("does not allow updating as anonymous user", () => {
    cy.visit("/stable/edit")

    cy.url().should("eq", Cypress.config().baseUrl + "login")
  })

  context("when user is logged in", () => {
    before(() => {
      cy.factoryBotCreate({ factory: "stable" }).its("body").as("stable")
    })

    it("allows updating as matching user", () => {
      cy.get(this.stable).then(stable => {
        cy.login({ id: stable.user_id }).then(() => {
          cy.visit("/stable/edit")

          cy.get('textarea[name="stable[description]"]').should("exist")
        })
      })
    })

    it("follows accessibility rules", () => {
      cy.get(this.stable).then(stable => {
        cy.login({ id: stable.user_id }).then(() => {
          cy.visit("/stable/edit")
          cy.injectAxe()
          cy.printA11y()
        })
      })
    })
  })
})
