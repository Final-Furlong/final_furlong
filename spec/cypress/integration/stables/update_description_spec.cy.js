describe("Update Stable Description", () => {
  it("cannot update as visitor", () => {
    cy.visit("/stable/edit")

    cy.assertUrl("/login")
  })

  context("when user is logged in", () => {
    it("allows description update", () => {
      cy.factory({ factory: "stable" })
        .its("body")
        .then(stable => {
          cy.login({ id: stable.user_id }).then(() => {
            cy.visit("/stable")

            cy.get("#breadcrumb-actions").within(() => {
              cy.get('a[href*="edit"]').click()
            })

            cy.assertUrl("/stable/edit")

            const description = "Test description"

            cy.get('textarea[name="stable[description]"]').should("exist")
            cy.get('textarea[name="stable[description]"]').type(description)
            cy.contains("Cancel").click()

            cy.assertUrl("/stable")
            cy.contains(description).should("not.exist")

            cy.visit("/stable/edit")
            cy.get('textarea[name="stable[description]"]').should("exist")
            cy.get('textarea[name="stable[description]"]').type(description)
            cy.get('.form-actions input[type="submit"]').click()

            cy.assertUrl("stable")

            cy.get("blockquote").within(() => {
              cy.contains(description)
            })
          })
        })
    })

    it("follows accessibility rules", () => {
      cy.factory({ factory: "stable" })
        .its("body")
        .then(stable => {
          cy.login({ id: stable.user_id }).then(() => {
            cy.testA11y("/stable/edit")
          })
        })
    })
  })
})
