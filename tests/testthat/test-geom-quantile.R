context("geom-quantile")

test_that("geom_quantile matches quantile regression", {
  set.seed(6531)
  x <- rnorm(10)
  df <- tibble::tibble(
    x = x,
    y = x^2 + 0.5 * rnorm(10)
  )

  ps <- ggplot(df, aes(x, y)) + geom_quantile()

  quants <- c(0.25, 0.5, 0.75)

  pred_rq <- predict(
    quantreg::rq(y ~ x,
      tau = quants,
      data = df
    ),
    tibble::tibble(
      x = seq(min(x), max(x), length = 100)
    )
  )

  pred_rq <- cbind(seq(min(x), max(x), length = 100), pred_rq)
  colnames(pred_rq) <- c("x", paste("Q", quants * 100, sep = "_"))

  ggplot_data <- tibble::as_tibble(layer_data(ps))

  pred_rq_test_25 <- pred_rq[, c("x", "Q_25")]
  colnames(pred_rq_test_25) <- c("x", "y")

  expect_equal(
    ggplot_data[ggplot_data$quantile == 0.25, c("x", "y")],
    pred_rq_test_25
  )

  pred_rq_test_50 <- pred_rq[, c("x", "Q_50")]
  colnames(pred_rq_test_50) <- c("x", "y")

  expect_equal(
    ggplot_data[ggplot_data$quantile == 0.5, c("x", "y")],
    pred_rq_test_50
  )

  pred_rq_test_75 <- pred_rq[, c("x", "Q_75")]
  colnames(pred_rq_test_75) <- c("x", "y")

  expect_equal(
    ggplot_data[ggplot_data$quantile == 0.75, c("x", "y")],
    pred_rq_test_75
  )
})
