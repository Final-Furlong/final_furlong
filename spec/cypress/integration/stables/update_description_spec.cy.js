describe("Update Stable Description", () => {
  it("does not allow updating as anonymous user", () => {
    cy.factoryBotCreate({ factory: "stable" })

    cy.request({
      url: "/stables/edit",
      failOnStatusCode: false
    }).then(resp => {
      expect(resp.status).to.eq(404)
      expect(resp.redirectedToUrl).to.eq(undefined)
    })
  })

  it("does allow updating as matching user", () => {
    cy.factoryBotCreate({ factory: "stable" })
      .its("body")
      .then(stable => {
        cy.login({ id: stable.user_id }).then(() => {
          cy.visit("/stables/edit")

          cy.get('input[name="stable[description]"]').should("exist")
        })
      })
  })

  xit("allows viewing as authenticated user", () => {
    cy.login({ username: "admin123" })

    cy.visit("/stables")
    cy.get("#main-navbar").within(() => {
      cy.contains("Log in").should("not.exist")
    })

    cy.get("#breadcrumbs").within(() => {
      cy.contains("All Stables")
    })
  })

  xit("shows all stables", () => {
    cy.visit("/stables")

    cy.get("#breadcrumbs").within(() => {
      cy.contains("All Stables")
    })
    cy.getBySelLike("stable-").should("have.length", 7)
  })
})
