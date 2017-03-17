/*
 * IMPORTANT! Insert here your API key
 */
const API_KEY = ''

const BASE_URL = 'https://api.stripe.com/v1/customers'

const headers = {
	'Authorization':`Bearer ${API_KEY}`,
	'Content-Type': 'application/x-www-form-urlencoded'
}

const encode = (key, value) =>
	`${encodeURIComponent(key)}=${encodeURIComponent(value)}`

const normalizeData = customer => [
	encode('account_balance', customer.balance * 1000),
	encode('description', customer.description),
	encode('email', customer.email),
	encode('metadata[firstName]', customer.firstName),
	encode('metadata[lastName]', customer.lastName)
].join('&')

export const request = (method, url, body) => {
  if (!API_KEY) {
    return Promise.reject('No API key found! check src/API.js and the README for more information.')
  }
	return fetch(url, { method, headers, body })
}

export const list = () => 
	request('GET', BASE_URL)

export const create = customer => 
	request('POST', BASE_URL, normalizeData(customer))

export const update = (id, customer) => 
	request('POST', `${BASE_URL}/${id}`, normalizeData(customer))

export const remove = id =>
	request('DELETE', `${BASE_URL}/${id}`)

