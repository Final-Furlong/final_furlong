const baseUrlTesla = 'https://www.tesla.com/'
const urlHttp = 'http://tesla.com'
it(urlHttp + ' end location', () => {
  cy.visit(urlHttp)
  cy.url().should('eq', baseUrlTesla)
})
it(urlHttp + ' redirect', () => {
  cy.request({
    url: urlHttp,
    followRedirect: false, // turn off following redirects
  }).then((resp) => {
    // redirect status code is 301
    expect(resp.status).to.eq(301)
    expect(resp.redirectedToUrl).to.eq(baseUrlTesla)
  })
})

const baseUrlTesla = 'https://www.tesla.com/'
const urlHttpsWww = 'https://www.tesla.com/'
it(urlHttpsWww + ' end location', () => {
  cy.visit(urlHttpsWww)
  cy.url().should('eq', baseUrlTesla)
})
it('200 homepage response', () => {
  cy.request({
    url: urlHttpsWww,
    followRedirect: false,
  }).then((resp) => {
    expect(resp.status).to.eq(200)
    expect(resp.redirectedToUrl).to.eq(undefined)
  })
})

const baseUrlTesla = 'https://www.tesla.com/'
const url404test = 'https://www.tesla.com/not-a-real-page'
it('404 \'not found\' response', () => {
  cy.request({
    url: url404test,
    followRedirect: false,
    failOnStatusCode: false,
  }).then((resp) => {
    expect(resp.status).to.eq(404)
    expect(resp.redirectedToUrl).to.eq(undefined)
  })
  cy.visit(url404test, { failOnStatusCode: false })
  cy.get('.error-code').should('contain', '404')
  cy.get('.error-text').should('contain', 'Page not found')
})
