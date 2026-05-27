---
id: Building Components with Radix UI
aliases: []
tags:
  - article
creation date: 2026-05-25 09:13
modification date: Monday 25th May 2026 09:13:25
source: https://refine.dev/blog/radix-ui/
status:
  - in-progress
---

## Other Sources:

- [Log Rocket: Radix UI Adoption Guide](https://blog.logrocket.com/radix-ui-adoption-guide/)

## Introduction

- [[Radix UI]] is a open source headless UI library that provides components for creating user-friendly, accessible, high quality [[React]] applications and design systems.
  - Being a headless UI library means that Radix UI doesn’t come shipped with any styles. Instead, we can use our preferred styling solutions to style the headless UI components to fit our brand and website requirements.
- It offers a wide range of accessible headless primitives, meant to expedite development by providing frequently used UI elements such as dialogues, selections, accordions, tabs, and more.

## Radix Building Blocks

- Radix UI consists of four building blocks:
  - Primitives
    - Collection of low-level UI component libraries with a focus on accessibility, customization, and the developer experience.
    - Designed with the goal of creating controllable headless components. All of its wiring is done internally, allowing you to start using the components as soon as possible.
    - Shipped with zero styles, providing you complete styling control.
  - Colours
    - Meticulously created color system used to create aesthethically pleasing web applications.
    - Includes a set of scales that are [[JavaScript]] objects designed to work with [[CSS]] to [[CSS-in-JS]] alternatives (for example, styled-components).
    - It also bundles the colors as raw CSS files which you can import straight into your files when using a bundler like Parcel or Webpack.
  - Icons
    - Radix Icons provides a set of 15×15 icons that are accessible as separate components and can be installed as a single package which you can import in your React components.
    - Radix Icons are also accessible in other formats, including downloadable SVGs, Figma, and Sketch files.
  - Themes
    - Radix Themes is a pre-styled component library that works out of the box and requires minimum configuration.
    - Radix Themes doesn't include a styling system.
      - There are no [[CSS]] or SX props, and no styling libraries are used inside. It's made with standard CSS.
      - However, the themes can be customized by altering the token system's CSS variables. The list of the variables supported by the token system is listed [here](https://github.com/radix-ui/themes/tree/main/packages/radix-ui-themes/src/styles/tokens).

### Radix Primitives

- Radix Primitives is a collection of unstyled UI components that Radix UI provides.
- Radix Primitives focuses on a component’s behavior rather than its style. Instead, we are in control of styling Radix components to match our taste and project requirements.
  - Radix UI only renders components with the markup they need to function properly. While other UI libraries ship their components with predefined styles, Radix UI takes a different approach and puts us in control of the design and appearance of its components from the onset.
- Radix Primitives features include:
  - **Out-of-the-box accessibility**: Radix UI components are fully accessible, are compatible with various devices and browsers, and support mouse, keyboard, and touch interactions
  - **Fully customizable and unstyled components**: We can use our preferred styling solution—Tailwind, Stitches, CSS, etc. — to customize the appearance of Radix components
  - Uncontrolled components
  - Fully-typed API

### Radix Colours

- Radix UI currently provides 396 colors via Radix Colors, its color system. An interesting thing about Radix UI that makes it different from other component libraries is that it doesn’t just provide a color system, but also provides recommendations on how to best apply the colors.
- Radix UI does this by grouping the colors into the following categories:
  - Colors for backgrounds
  - Colors for interactive components
  - Colors for borders and separators
  - Solid colors
  - Colors for accessible texts

### Radix Icons

- Similar to icon libraries like React Icons, Radix Icons is a collection of 15×15 SVG icons created by the Radix UI team.
- Some important things to know about Radix Icons are:
  - There are over 300 icons across different categories like typography, arrows, and logos
  - The width and height of the icons are hard hard-coded
  - All Radix Icons are available as React components.
  - Unlike React Icons, which provides a `size` prop for adjusting the size of its icons, Radix Icons does not. This means we’ll have to change each icon’s width and height properties ourselves via SVG code or CSS styles. This can be inefficient, particularly when working with several icons

### Radix Themes

- Radix Themes is Radix UI’s theming system. It allows us to customize the appearance of Radix UI components by defining custom values for accent colors, border radius, light and dark mode, and scale. The theming system also provides component variants, like `classic`, `solid`, and `soft`.
- To use Radix Themes in our application, we have to import the `Theme` provider from the `@radix-ui/themes` package and plug it into the application’s `root`.
  - The ThemePanel component in the code above gives us a visual tool for creating custom themes that fit our needs.
    - Radix UI provides a [theme playground](https://www.radix-ui.com/themes/playground) for exploring the theme panel:

```jsx
import { Theme, ThemePanel } from "@radix-ui/themes";

export default function () {
  return (
    <Theme>
      <MyApp />
      <ThemePanel />
    </Theme>
  );
}
```

- Some examples of Theme components are as follows:

#### Reset Component

- The Reset component is used to forcibly reset browser styles for a specified element.
- Under the hood, it generates a Slot primitive (a Radix primitive) which does the following:
  - Accepts one React element as its child.
  - Removes opinionated browser styles.
  - Sets idiomatic layout defaults, such as `display: block` for photos or `width: Stretch` for inputs.
  - Sets the cursor style based on your theme settings.
  - Adds the property `box-sizing: border-box`.

```jsx
import { Reset } from "@radix-ui/themes";

function App() {
  return (
    <div>
      <div className="flex gap-2">
        <div className="w-6/12">
          <h1>Without Reset Component</h1>
          <abbr title="Abbreviation">ABR</abbr>
        </div>

        <div className="w-6/12">
          <h1>With Reset Component</h1>
          <Reset>
            <abbr title="Abbreviation">ABR</abbr>
          </Reset>
        </div>
      </div>
    </div>
  );
}
```

![[Pasted image 20260525093919.png]]

#### Grid Component

- The Grid component is a component for designing grid layouts. This component is based on the `div` element and accepts common margin `props`.

```jsx
import { Grid, Box } from "@radix-ui/themes";

function App() {
  return (
    <div>
      <Grid columns="3" gap="3" rows="repeat(3, 40px)" width="auto">
        <Box
          width={"200px"}
          height={"50px"}
          className="bg-black text-center text-white"
        >
          Box 1
        </Box>
        <Box
          width={"200px"}
          height={"50px"}
          className="bg-black text-center text-white"
        >
          Box 2
        </Box>
        <Box
          width={"200px"}
          height={"50px"}
          className="bg-black text-center text-white"
        >
          Box 3
        </Box>
        <Box
          width={"200px"}
          height={"50px"}
          className="bg-black text-center text-white"
        >
          Box 4
        </Box>
        <Box
          width={"200px"}
          height={"50px"}
          className="bg-black text-center text-white"
        >
          Box 5
        </Box>
        <Box
          width={"200px"}
          height={"50px"}
          className="bg-black text-center text-white"
        >
          Box 6
        </Box>
      </Grid>
    </div>
  );
}
```

![[Pasted image 20260525093937.png]]

#### Theme component

- The Theme component wraps all or portion of a React tree to enable theme customization.

```jsx
import {
  Grid,
  Button,
  TextArea,
  Heading,
  Flex,
  Card,
  Theme,
  Text,
} from "@radix-ui/themes";

function App() {
  return (
    <div>
      <Card size="2">
        <Flex gap="6">
          <Flex direction="column" gap="3">
            <Heading as="h5" size="2">
              Regular card
            </Heading>
            <Grid gap="1">
              <Text as="div" weight="bold" size="2" mb="1">
                Feedback
              </Text>
              <TextArea placeholder="Write your feedback…" />
            </Grid>
            <Button>Send</Button>
          </Flex>

          <Theme accentColor="cyan" radius="full">
            <Card size="2">
              <Flex gap="6">
                <Flex direction="column" gap="3">
                  <Heading as="h5" size="2">
                    Card with cyan theme
                  </Heading>
                  <Grid gap="1">
                    <Text as="div" weight="bold" size="2" mb="1">
                      Feedback
                    </Text>
                    <TextArea placeholder="Write your feedback…" />
                  </Grid>
                  <Button>Send</Button>
                </Flex>

                <Theme accentColor="orange">
                  <Card size="2">
                    <Flex direction="column" gap="3">
                      <Heading as="h5" size="2">
                        Card with orange theme
                      </Heading>
                      <Grid gap="1">
                        <Text as="div" weight="bold" size="2" mb="1">
                          Feedback
                        </Text>
                        <TextArea placeholder="Write your feedback…" />
                      </Grid>
                      <Button>Send</Button>
                    </Flex>
                  </Card>
                </Theme>
              </Flex>
            </Card>
          </Theme>
        </Flex>
      </Card>
    </div>
  );
}
```

![[Pasted image 20260525093954.png]]

## Code Example for using Radix UI

### Create a React Application

- Create a [[React]] application using [[Vite]]: `pnpm create vite`

### Add a Popover Primitive

- To install a primitive component, add the name of the component to a radix-ui/ prefix as shown: `pnpm install @radix-ui/react-popover@latest -E`
- Create a `PopoverDemo` component and add it's styles:

```jsx
import * as Popover from "@radix-ui/react-popover";
import "./PopoverDemo.css";

const PopoverDemo = () => {
  <Popover.Root>
    <Popover.Trigger className="popover-trigger">More info</Popover.Trigger>
    <Popover.Portal>
      <Popover.Content className="popover-content">
        Some more info...
        <Popover.Arrow className="popover-arrow" />
      </Popover.Content>
    </Popover.Portal>
  </Popover.Root>;
};

export default PopoverDemo;
```

```css
.popover-trigger {
  background-color: white;
  border-radius: 4px;
}

.popover-content {
  border-radius: 4px;
  padding: 20px;
  width: 260px;
  background-color: white;
}

.popover-arrow {
  fill: white;
}
```

### Installing Themes

- To install themes: `pnpm install @radix-ui/themes`
- At your application's entry point, `main.jsx`, import the radix theme styles and wrap your application with the `<Theme>` component.

```jsx
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import "./index.css";
import "@radix-ui/themes/styles.css";
import App from "./App.jsx";
import { Theme } from "@radix-ui/themes";

createRoot(document.getElementById("root")).render(
  <StrictMode>
    <Theme>
      <App />
    </Theme>
  </StrictMode>,
);
```

- Add theme components to your application:

```jsx
import { Button, Flex, Text } from "@radix-ui/themes";

function App() {
  return (
    <Flex direction="column" gap="2">
      <Text>Hello from Radix Themes :)</Text>
      <Button>Let's Go</Button>
    </Flex>
  );
}

export default App;
```

### Installing icons

- To install icons: `pnpm install @radix-ui/react-icons`
- Use the icons in your application:

```jsx
import { FaceIcon, ImageIcon, SunIcon } from "@radix-ui/react-icons";
import { Button, Flex, Text } from "@radix-ui/themes";

function App() {
  return (
    <Flex direction="column" gap="2">
      <Text>Hello from Radix Themes :)</Text>
      <Button>Let's Go</Button>
      <FaceIcon />
      <SunIcon />
      <ImageIcon />
    </Flex>
  );
}

export default App;
```

### Installing Colors

- To install colors: `pnpm install @radix-ui/colors`
- These can be imported as Vanilla CSS or as objects.

```css
/* Import only the scales you need */
@import "@radix-ui/colors/gray.css";
@import "@radix-ui/colors/blue.css";
@import "@radix-ui/colors/green.css";
@import "@radix-ui/colors/red.css";
@import "@radix-ui/colors/gray-dark.css";
@import "@radix-ui/colors/blue-dark.css";
@import "@radix-ui/colors/green-dark.css";
@import "@radix-ui/colors/red-dark.css";

/* Use the colors as CSS variables */
.button {
  background-color: var(--blue-4);
  color: var(--blue-11);
  border-color: var(--blue-7);
}
.button:hover {
  background-color: var(--blue-5);
  border-color: var(--blue-8);
}
```

```js
import {
  gray,
  blue,
  red,
  green,
  grayDark,
  blueDark,
  redDark,
  greenDark,
} from "@radix-ui/colors";
```

- You can then use them as follows:

```jsx
import { FaceIcon, ImageIcon, SunIcon } from "@radix-ui/react-icons";
import { Button, Flex, Text } from "@radix-ui/themes";
import "./App.css";

function App() {
  return (
    <Flex direction="column" gap="2">
      <Text>Hello from Radix Themes :)</Text>
      <Button className="button">Let's Go</Button>
      <FaceIcon />
      <SunIcon />
      <ImageIcon />
    </Flex>
  );
}

export default App;
```

### Adding animations using Motion

- Since the [[Radix Primitives]] are unstyled by default, we can easily add animations using the [[Motion]] package.
- Install the [[Motion]] packages: `pnpm install motion`
- Install [[Tailwind CSS]]: `pnpm install tailwindcss @tailwindcss/vite`
- Configure the [[Vite]] plugin:

```js
import { defineConfig } from "vite";
import tailwindcss from "@tailwindcss/vite";

export default defineConfig({
  plugins: [tailwindcss()],
});
```

- Import using `@import` your Tailwind styles at the root [[CSS]]:

```css
@import "tailwindcss";
```

- Create the animated dialog as follows:

```jsx
import * as Dialog from "@radix-ui/react-dialog";
import { motion } from "motion/react";

const modalVariants = {
  hidden: { opacity: 0, y: -20 },
  visible: { opacity: 1, y: 0 },
};

const AnimatedDialog = () => {
  return (
    <Dialog.Root>
      <Dialog.Trigger>Open Dialog</Dialog.Trigger>
      <Dialog.Portal>
        <Dialog.Overlay asChild>
          <motion.div
            initial="hidden"
            animate="visible"
            exit="hidden"
            variants={modalVariants}
            transition={{ duration: 0.3 }}
            className="fixed inset-0 bg-black bg-opacity-50"
          />
        </Dialog.Overlay>
        <Dialog.Content asChild>
          <motion.div
            initial="hidden"
            animate="visible"
            exit="hidden"
            variants={modalVariants}
            transition={{ duration: 0.3 }}
            className="fixed left-1/2 top-1/2 -translate-x-1/2 -translate-y-1/2 rounded-md bg-white p-6"
          >
            <h2>Animated Radix Dialog</h2>
            <p>This dialogue fades in and out nicely!</p>
            <Dialog.Close>Close</Dialog.Close>
          </motion.div>
        </Dialog.Content>
      </Dialog.Portal>
    </Dialog.Root>
  );
};

export default AnimatedDialog;
```

### Create an Edit Profile Dialog

- The anatomy of a Dialog with Radix consists of the following eight elements:
  - Root: Contains all the components of a Dialog.
  - Trigger: Contains the button that will be used to trigger the Dialog.
  - Portal: When used, it move your overlay and content elements into the body element in the DOM.
  - Overlay: This is a layer that, when the dialog is open, covers the inactive area of the view.
  - Content: Contains holds the contents of the dialog.
  - Title: Title holds the title of the content when the dialog is opened.
  - Description: Holds the description of the content when the dialog is opened.
  - Close: Holds the button that closes the dialog.
- The component is as follows:

```jsx
import * as Dialog from "@radix-ui/react-dialog";
import { Cross2Icon } from "@radix-ui/react-icons";

function EditProfileDialog() {
  return (
    <div style={{ marginTop: "150px" }}>
      <Dialog.Root>
        <Dialog.Trigger asChild>
          <button className="text-violet11 shadow-blackA4 hover:bg-mauve3 inline-flex h-[35px] items-center justify-center rounded-[4px] bg-white px-[15px] font-medium leading-none shadow-[0_2px_10px] focus:shadow-[0_0_0_2px] focus:shadow-black focus:outline-none">
            Edit profile
          </button>
        </Dialog.Trigger>

        <Dialog.Portal>
          <Dialog.Overlay className="bg-blackA6 data-[state=open]:animate-overlayShow fixed inset-0" />
          <Dialog.Content className="data-[state=open]:animate-contentShow fixed left-[50%] top-[50%] max-h-[85vh] w-[90vw] max-w-[450px] translate-x-[-50%] translate-y-[-50%] rounded-[6px] bg-white p-[25px] shadow-[hsl(206_22%_7%_/_35%)_0px_10px_38px_-10px,_hsl(206_22%_7%_/_20%)_0px_10px_20px_-15px] focus:outline-none">
            <Dialog.Title className="text-mauve12 m-0 text-[17px] font-medium">
              Edit profile
            </Dialog.Title>
            <Dialog.Description className="text-mauve11 mb-5 mt-[10px] text-[15px] leading-normal">
              Make changes to your profile here. Click save when you're done.
            </Dialog.Description>
            <fieldset className="mb-[15px] flex items-center gap-5">
              <label
                className="text-violet11 w-[90px] text-right text-[15px]"
                htmlFor="name"
              >
                Name
              </label>
              <input
                className="text-violet11 shadow-violet7 focus:shadow-violet8 inline-flex h-[35px] w-full flex-1 items-center justify-center rounded-[4px] px-[10px] text-[15px] leading-none shadow-[0_0_0_1px] outline-none focus:shadow-[0_0_0_2px]"
                id="name"
                defaultValue="Pedro Duarte"
              />
            </fieldset>
            <fieldset className="mb-[15px] flex items-center gap-5">
              <label
                className="text-violet11 w-[90px] text-right text-[15px]"
                htmlFor="username"
              >
                Username
              </label>
              <input
                className="text-violet11 shadow-violet7 focus:shadow-violet8 inline-flex h-[35px] w-full flex-1 items-center justify-center rounded-[4px] px-[10px] text-[15px] leading-none shadow-[0_0_0_1px] outline-none focus:shadow-[0_0_0_2px]"
                id="username"
                defaultValue="@peduarte"
              />
            </fieldset>
            <div className="mt-[25px] flex justify-end">
              <Dialog.Close asChild>
                <button className="bg-green4 text-green11 hover:bg-green5 focus:shadow-green7 inline-flex h-[35px] items-center justify-center rounded-[4px] px-[15px] font-medium leading-none focus:shadow-[0_0_0_2px] focus:outline-none">
                  Save changes
                </button>
              </Dialog.Close>
            </div>
            <Dialog.Close asChild>
              <button
                className="text-violet11 hover:bg-violet4 focus:shadow-violet7 absolute right-[10px] top-[10px] inline-flex h-[25px] w-[25px] appearance-none items-center justify-center rounded-full focus:shadow-[0_0_0_2px] focus:outline-none"
                aria-label="Close"
              >
                <Cross2Icon />
              </button>
            </Dialog.Close>
          </Dialog.Content>
        </Dialog.Portal>
      </Dialog.Root>
    </div>
  );
}

export default EditProfileDialog;
```

![[Pasted image 20260525104956.png]]

### Slider Component

- The following four components make up the anatomy of a Slider made with Radix:
  - Root: Comprising every component of a slider
  - Track: The Slider-containing track.
  - Range: The portion of the range that has to fit inside the slider.
  - Thumb: The thumb can be moved.

```jsx
import * as Slider from "@radix-ui/react-slider";

function SliderComponent() {
  return (
    <div>
      <Slider.Root
        className="relative flex h-5 w-[200px] touch-none select-none items-center"
        defaultValue={[50]}
        max={100}
        step={1}
      >
        <Slider.Track className="relative h-[3px] grow rounded-full bg-black">
          <Slider.Range className="absolute h-full rounded-full bg-red-100" />
        </Slider.Track>
        <Slider.Thumb
          className="shadow-blackA4 hover:bg-violet3 focus:shadow-blackA5 block h-5 w-5 rounded-[10px] bg-red-100 shadow-[0_2px_10px] focus:shadow-[0_0_0_5px] focus:outline-none"
          aria-label="Volume"
        />
      </Slider.Root>
    </div>
  );
}

export default SliderComponent;
```

![[Pasted image 20260525105211.png]]
