describe("Stable Index", () => {
  it("allows viewing as anonymous user", () => {
    cy.visit("/stables")

    cy.contains("All Stables")
  })

  it("allows viewing as authenticated user", () => {
    cy.login({ username: "admin123" })

    cy.visit("/stables")
    cy.get("#main-navbar").within(() => {
      cy.contains("Log in").should("not.exist")
    })

    cy.contains("All Stables")
  })

  it("shows all stables", () => {
    cy.visit("/stables")

    cy.contains("All Stables")
    cy.getBySelLike("stable-").should("have.length", 7)
  })

  it("follows accessibility rules", () => {
    cy.testA11y("/stables")
  })
})
