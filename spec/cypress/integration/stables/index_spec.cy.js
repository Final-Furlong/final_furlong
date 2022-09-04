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

  it("shows online status", () => {
    cy.factory({ factory: "stable", last_online_at: Date.now() })
      .its("body")
      .then(stable => {
        cy.login({ id: stable.user_id }).then(() => {
          cy.visit("/stables")

          cy.contains("All Stables")
          cy.get(".badge-offline").should("have.length", 7)
          cy.get(".badge-online").should("have.length", 1)
        })
      })
  })

  it("follows accessibility rules", () => {
    cy.testA11y("/stables")
  })
})
