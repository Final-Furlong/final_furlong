describe("Update Stable Description", () => {
  it("does not allow updating as anonymous user", () => {
    cy.visit("/stables")

    cy.get("#breadcrumbs").within(() => {
      cy.contains("All Stables")
    })
  })

  it("allows viewing as authenticated user", () => {
    cy.login({ username: "admin123" })

    cy.visit("/stables")
    cy.get("#main-navbar").within(() => {
      cy.contains("Log in").should("not.exist")
    })

    cy.get("#breadcrumbs").within(() => {
      cy.contains("All Stables")
    })
  })

  it("shows all stables", () => {
    cy.visit("/stables")

    cy.get("#breadcrumbs").within(() => {
      cy.contains("All Stables")
    })
    cy.getBySelLike("stable-").should("have.length", 7)
  })
})
