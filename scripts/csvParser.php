<?php
date_default_timezone_set('America/Los_Angeles');
$stock = 'rsh';
$history = file('../data/'.$stock.'.csv');

function attributesFromLine($str) {
		$vals = explode(',', $str); ///THIS DOESN'T WORK!!!
		$ret = new stdClass();
		$ret->date = strtotime($vals[0]);
		$ret->value = isset($vals[6]) ? (float) $vals[1] : null;
		return $ret;
}

class Price {
	public $date;
	public $pastHundred;
	public $value;
	
	public function __construct($options) {
		$this->date = $options->date;
		if (isset($options->pastHundred)) {
			$this->pastHundred = $options->pastHundred;
		}
		$this->value = $options->value;
		$previousAverage = isset($options->average) ? $options->average : null;
	}

	public function getMatFormat() {

	}

	public function toString() {
		return (string) $this->value;
	}
	public function getFinalDayProfit() {
		$ret = (($this->next / $this->value)-1)*5;
		return $ret;
	}
}

class Prices {
	private $prices = array();
	private $priceMaxMins = array(array(0), array(100000));
	private $averagePrice;
	private $profitMaxMins = array(array(-100000), array(100000));
	private $averageProfit;
	private $dateMaxMins = array(array(0), array(10000000));
	private $averageDate;

	public function __construct() {

	}

	public function addPrice($price) {
		if ($price->value > $this->priceMaxMins[0][0]) {
			array_unshift($this->priceMaxMins[0], $price->value);
		} 
		if (count($this->priceMaxMins) < 1 || $price->value < $this->priceMaxMins[1][0]) {
			array_unshift($this->priceMaxMins[1], $price->value);
		} 
		if ($price->getFinalDayProfit() > $this->profitMaxMins[0][0]) {
			array_unshift($this->profitMaxMins[0], $price->getFinalDayProfit());
		} 
		if (count($this->profitMaxMins) < 1 || $price->getFinalDayProfit() < $this->profitMaxMins[1][0]) {
			array_unshift($this->profitMaxMins[1], $price->getFinalDayProfit());
		} 
		if ($price->date > $this->dateMaxMins[0][0]) {
			array_unshift($this->dateMaxMins[0], $price->date);
		} 
		if (count($this->dateMaxMins[1]) < 1 || $price->date < $this->dateMaxMins[1][0]) {
			array_unshift($this->dateMaxMins[1], $price->date);
		} 
		$this->averageIn($price);
		array_push($this->prices, $price);
	}

	public function averageIn($price) {
		$this->averageProfit *= count($this->prices) / (count($this->prices) + 1);
		$this->averageProfit += $price->getFinalDayProfit() / (count($this->prices) + 1);
		$this->averagePrice *= count($this->prices) / (count($this->prices) + 1);
		$this->averagePrice += $price->value / (count($this->prices) + 1);
		$this->averageDate *= count($this->prices) / (count($this->prices) + 1);
		$this->averageDate += $price->date / (count($this->prices) + 1);
	}

	public function getDateRange() {
		return ($this->dateMaxMins[0][0] - $this->dateMaxMins[1][0]);
	}

	public function getPriceRange() {
		return ($this->priceMaxMins[0][0] - $this->priceMaxMins[1][0]);
	}
	public function getProfitRange() {
		var_dump($this->profitMaxMins);
		return ($this->profitMaxMins[0][0] - $this->profitMaxMins[1][0]);
	}
	
	public function toString() {
		$ret = '';
		foreach ($this->prices as $i=>$price) {
			$ret .= Prices::scaleFeature($price->getFinalDayProfit(), 0, 1).',';
			foreach ($price->pastHundred as $n => $histPrice) {
				$ret .= Prices::scaleFeature((($histPrice/$price->value)-1)*5, 0, 1);
				$ret .= ($n != 9) ? ',' : PHP_EOL;
			}
		}
		var_dump($this->getPriceRange());
		return $ret;
	}

	public static function scaleFeature($value, $feature_mean, $feature_range) {
		return (($value - $feature_mean) / $feature_range); 
	}
}

$prices = new Prices();
$pastHundred = array();
$history = array_reverse($history);
$pastPrices = array(attributesFromLine($history[0])->value);
foreach ($history as $i => $lineItem) {
	if ($i + 2 == count($history)) {
		continue;
	}
	$vals = attributesFromLine($lineItem);
	array_unshift($pastPrices, $vals->value);
	if (count($pastHundred) > 9) {
		if ($vals->value > 0) {
			$newPrice = new Price($vals);
			$newPrice->pastHundred = $pastHundred;
			$newPrice->next = attributesFromLine($history[$i+1])->value;
			$prices->addPrice($newPrice);
		}
		array_pop($pastHundred);
	}
	array_unshift($pastHundred, $vals->value);
}

$storeData = fopen("../data/$stock"."_stock.csv", 'w');
fwrite($storeData, $prices->toString());
fclose($storeData);
