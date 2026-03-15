import { BrowserRouter as Router, Routes, Route } from "react-router-dom";

import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import CaregiverVerification from "./pages/CaregiverVerification";
import Users from "./pages/Users";
import Bookings from "./pages/Bookings";
import ProtectedRoute from "./components/ProtectedRoute";

function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Login />} />
        <Route element={<ProtectedRoute />}>
          <Route path="/dashboard" element={<Dashboard />} />
          <Route path="/caregivers" element={<CaregiverVerification />} />
          <Route path="/users" element={<Users />} />
          <Route path="/bookings" element={<Bookings />} />
        </Route>
      </Routes>
    </Router>
  );
}

export default App;
