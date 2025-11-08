export const debounce = (callback, delay) => {
  let timeout

  return function (...args) {
    const context = this
    clearTimeout(timeout)

    timeout = setTimeout(() => callback.apply(context, args), delay)
  }
}
