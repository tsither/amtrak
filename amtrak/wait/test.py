import tkinter as tk
from PIL import Image, ImageTk
import tkinter as tk
from PIL import Image, ImageTk

ENV_IMAGE_PATH = '/Users/mymac/Desktop/Trains/flatland/envs/png/env_001--2_4.png'

def on_button_click():
    print("Button clicked!")

# Create the main window
root = tk.Tk()
root.title("Flatland")
root.geometry("800x600")  # Set the window size

# Load the PNG image
image = Image.open(ENV_IMAGE_PATH)
background_image = ImageTk.PhotoImage(image)

# Create a canvas and set the image as the background
canvas = tk.Canvas(root, width=image.width, height=image.height)
canvas.pack(fill="both", expand=True)
canvas.create_image(0, 0, image=background_image, anchor="nw")

# Add numbers on the canvas
# Replace this loop with logic to determine where numbers should appear
for i in range(1, 6):  # Example: 5 numbers
    x = 50 * i  # Spacing between numbers
    y = 50  # Fixed height
    canvas.create_text(x, y, text=str(i), fill="red", font=("Helvetica", 20))

# Add a button on top of the canvas
button = tk.Button(root, text="Click Me", command=on_button_click)
button_window = canvas.create_window(600, 100, anchor="w", window=button)

# Run the main loop
root.mainloop()

