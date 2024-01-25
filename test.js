const array = [49, 86, 63, 73, 81, 69]

let firstEle = array[0]
let secondEle = array[0]

array.forEach((item) => {
  if (firstEle < item) {
    secondEle = firstEle
    firstEle = item
  } else {
    if (secondEle < item) {
      secondEle = item
    }
  }
})

console.log(firstEle, secondEle)
