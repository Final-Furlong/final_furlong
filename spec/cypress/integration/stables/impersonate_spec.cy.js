describe("Impersonate Stable Index", () => {
  it("does not allow impersonating as visitor", () => {
    cy.visit("/stables")

    cy.get(".stable.card:first").within(() => {
      cy.get('a[href*="stables/"]').click()
    })

    cy.assertUrl("stables/", "contains")
    // cy.contains('')

    cy.get("#breadcrumb-actions").within(() => {
      cy.contains("Impersonate").should("not.exist")
    })
  })

  it("does not allow impersonating as regular user", () => {
    cy.factory({ factory: "stable" })
      .its("body")
      .then(stable => {
        cy.login({ id: stable.user_id }).then(() => {
          cy.visit("/stables")

          cy.get(".stable.card:first").within(() => {
            cy.get('a[href*="stables/"]').click()
          })

          cy.assertUrl("stables/", "contains")

          cy.get("#breadcrumb-actions").within(() => {
            cy.contains("Impersonate").should("not.exist")
          })
        })
      })
  })

  it("allows impersonating as admin", () => {
    cy.factory({ factory: "user", admin: true })
      .its("body")
      .then(admin => {
        cy.login({ id: admin.id }).then(response => {
          const adminStable = response.body.stable
          cy.factory({ factory: "stable", name: "AA Stable" })
            .its("body")
            .then(userStable => {
              cy.visit("/stables")

              cy.get(".stable.card").contains(userStable.name).click({ force: true })

              cy.assertUrl("stables/", "contains")
              cy.get("h1").contains(userStable.name).should("exist")
              cy.contains("Offline")

              cy.get("#breadcrumb-actions").within(() => {
                cy.contains("Impersonate").click()
              })

              cy.get("#impersonation-alert").should("exist")

              cy.assertUrl("/")

              cy.contains("Signed in as").should("exist")
              cy.contains(userStable.name).should("exist")
              cy.contains(adminStable.name).should("not.exist")
              cy.contains("Offline") // do not update user's online status when impersonating

              cy.contains("(Sign Out)").click()
              cy.assertUrl("/")
              cy.get("#impersonation-alert").should("not.exist")
              cy.contains("You've stopped impersonating").should("exist")
              cy.contains(adminStable.name).should("exist")
            })
        })
      })
  })
})
