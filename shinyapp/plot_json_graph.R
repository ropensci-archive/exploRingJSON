plot_json_graph <- function(.x, legend = TRUE, vertex.size = 6,
                            edge.color = 'grey70', edge.width = .5,
                            show.labels = TRUE, plot = TRUE,
                            ...) {

  if (!is.tbl_json(.x)) .x <- as.tbl_json(.x)

  if (nrow(.x) != 1) stop("nrow(.x) not equal to 1")

  structure <- .x %>% json_structure

  type_colors <- RColorBrewer::brewer.pal(6, "Accent")

  graph_edges <- structure %>%
    filter(!is.na(parent.id)) %>%
    select(parent.id, child.id)

  graph_vertices <- structure %>%
    transmute(child.id,
              vertex.color = type_colors[as.integer(type)],
              vertex.label = name)

  if (!show.labels)
    graph_vertices$vertex.label <- rep(NA_character_, nrow(graph_vertices))

  g <- igraph::graph_from_data_frame(graph_edges, vertices = graph_vertices,
                             directed = FALSE)

  if (plot) {
    op <- par(mar = c(0, 0, 0, 0))
    plt <- igraph::plot.igraph(g,
         vertex.color = igraph::V(g)$vertex.color,
         vertex.size  = vertex.size,
         vertex.label = igraph::V(g)$vertex.label,
         vertex.frame.color = NA,
         layout = igraph::layout_with_kk,
         edge.color = edge.color,
         edge.width = edge.width,
         ...)

    if (legend)
      legend(x = -1.3, y = -.6, levels(structure$type), pch = 21,
             col= "white", pt.bg = type_colors,
             pt.cex = 2, cex = .8, bty = "n", ncol = 1)

    par(op)
  }

  invisible(g)

}
