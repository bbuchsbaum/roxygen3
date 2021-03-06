#' An output generator for the \file{NAMESPACE} file.
#'
#' @dev
#' @export
#' @rdname writeNamespace
#' @param object Object to proccess, starting at a \linkS4class{Bundle},
#'   breaking down into \linkS4class{Block}s then individual
#'   \linkS4class{Tag}s
NULL

setMethod("writeNamespace", "PackageBundle", function(object) {
  in_dir(object@path, callNextMethod())
})
setMethod("writeNamespace", "Bundle", function(object) {
  ns <- build_namespace(object@blocks)
  write_namespace(ns)
})
setMethod("writeNamespace", "Block", function(object) {
  compact(lapply(object@tags, writeNamespace))
})
setMethod("writeNamespace", "Tag", function(object) NULL)

build_namespace <- function(blocks) {
  lines <- unlist(lapply(blocks, writeNamespace), use.names = FALSE)
  with_collate("C", sort(unique(lines)))
}

write_namespace <- function(ns) {
  write_if_different("NAMESPACE", ns)
}


# Useful output commands -----------------------------------------------------

ns_each <- function(directive, values) {
  values <- values[values != ""]
  if (length(values) == 0) return()

  str_c(directive, "(", quote_if_needed(values), ")")
}
ns_call <- function(directive, values) {
  values <- values[values != ""]
  if (length(values) == 0) return()

  args <- paste(names(values), " = ", values, collapse = ", ", sep = "")
  str_c(directive, "(", args, ")")
}
ns_repeat1 <- function(directive, values) {
  values <- values[values != ""]
  if (length(values) == 0) return()

  str_c(directive, "(", quote_if_needed(values[1]), ",",
    quote_if_needed(values[-1]), ")")
}
