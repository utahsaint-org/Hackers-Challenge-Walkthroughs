
package main

import (
	"image/gif"
	"image/color"
	"math"
	"fmt"
	"os"
	"log"
)

// How far is this pixel color away from green and white?
func distance(c color.Color) (int, int) {
	return distance_green(c), distance_white(c)
}

// How far is this pixel color away from green?
func distance_green(c color.Color) int {
	r, g, b, _ := c.RGBA()
	r, g, b = r/256, g/256, b/256
	fr, fg, fb := float64(r) - 155.0, float64(g) - 204.0, float64(b) - 79.0
	fr, fg, fb = fr * fr, fg * fg, fb * fb
	return int(math.Sqrt(fr + fg + fb))
}

// How far is this pixel color away from white?
func distance_white(c color.Color) int {
	r, g, b, _ := c.RGBA()
	r, g, b = r/256, g/256, b/256
	fr, fg, fb := float64(r) - 255.0, float64(g) - 255.0, float64(b) - 255.0
	fr, fg, fb = fr * fr, fg * fg, fb * fb
	return int(math.Sqrt(fr + fg + fb))
}

func main() {
	file, err := os.Open("m.gif")
	if err != nil {
		log.Fatal(err)
	}
	defer file.Close()

	gif, err := gif.DecodeAll(file)
	if err != nil {
		log.Fatal(err)
	}

	// Scan across these X values and sample the color
	// of each frame.
	var xs = [...]int { 538, 608, 678, 748, 819, 890, 956, 1027 }
	y := 344

	var resultstr string

	// for each frame
	for i := 0; i < len(gif.Image); i++ {
		var str string

		// for each LED
		for j := 0; j < len(xs); j++ {
			var x = xs[j]
			var c = gif.Image[i].Palette[gif.Image[i].ColorIndexAt(x, y)]
			g, w := distance(c)

			if g < w {
				// Green: 1
				str += "1"
			} else if w < g {
				// White: 0
				str += "0"
			} else {
				// Shouldn't happen...
				fmt.Print("(", g, w, c, ")")
			}
		}

		// Turn the string of 1's and 0's into an integer and
		// add its character value to our result string.
		var a rune
		fmt.Sscanf(str, "%b", &a)
		resultstr += string(a)
	}

	// Show the result
	fmt.Println(resultstr)
}
