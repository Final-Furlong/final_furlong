describe("More Rails using factory bot examples", function () {
  beforeEach(() => {
    cy.app("clean") // have a look at cypress/app_commands/clean.rb
  })

  it("using response from factory bot", function () {
    cy.appFactories([["create", "admin", { email: "admin@example.com", password: "Password1!" }]]).then(results => {
      const user = results[0]

      cy.visit("/login")
      cy.log(`user: ${user.email}`)
    })
  })

  // it('using response from multiple factory bot', function() {
  //   cy.appFactories([
  //     ['create', 'post', { title: 'My First Post'} ],
  //     ['create', 'post', { title: 'My Second Post'} ]
  //   ]).then((results) => {
  //     cy.visit(`/posts/${results[0].id}`);
  //     cy.contains("My First Post")
  //
  //     cy.visit(`/posts/${results[1].id}`);
  //     cy.contains("My Second Post")
  //   });
  // })
})
