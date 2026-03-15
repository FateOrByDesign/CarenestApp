const API_BASE = process.env.REACT_APP_API_URL || "http://localhost:5001/api";

export const getAuthHeaders = () => ({
  "Content-Type": "application/json",
  Authorization: `Bearer ${localStorage.getItem("token")}`,
});

export default API_BASE;
