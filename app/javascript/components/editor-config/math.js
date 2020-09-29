import { Plugin } from 'prosemirror-state'
import MathView from '../MathView'

export function math(options) {
  return new Plugin({
    props: {
      nodeViews: {
        math_inline: (node, view, getPos) => {
          return new MathView(node, view, getPos)
        },
      },
    },
  })
}
